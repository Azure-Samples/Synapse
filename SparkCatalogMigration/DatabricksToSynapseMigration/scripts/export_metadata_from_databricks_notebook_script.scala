// Databricks notebook source
var IntermediateFolderPath = "abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/intermediate_output/"
var StorageAccountName = "<storage_account_name>"
var StorageAccountAccessKey = "<storage_account_access_key>"

var DatabaseNames = "" 


// COMMAND ----------


spark.conf.set(
  "fs.azure.account.key." + StorageAccountName + ".dfs.core.windows.net",
  StorageAccountAccessKey
)

// COMMAND ----------

import java.net.URI
import java.util.Calendar

import scala.collection.mutable.{ListBuffer, Map, Set}
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.catalyst._
import org.apache.spark.sql.catalyst.catalog._
import org.json4s._
import org.json4s.JsonAST.JString
import org.json4s.jackson.Serialization

object ExportMetadata {

  lazy val spark = SparkSession
    .builder()
    .getOrCreate()

  import spark.implicits._

  val DatabaseType = "database"
  val TableType = "table"
  val PartitionType = "partition"

  case class CatalogPartitions(database: String, table: String, tablePartitons: Seq[CatalogTablePartition])

  case class CatalogTables(database: String, tables: Seq[CatalogTable])

  case class CatalogStat(entityType: String, count: Int, database: Option[String], table: Option[String])

  def ConvertToJsonStringList(objs: List[Object]):List[String] = {

    // define custom json serializer for java.net.URI
    case object URISerializer extends CustomSerializer[URI](format => ( {
      case JString(uri) => new URI(uri)
    }, {
      case uri: URI => JString(uri.toString())
    }))

    // define custom json serializer for  org.apache.spark.sql.types.StructType
    case object SturctTypeSerializer extends CustomSerializer[StructType](format => ( {
      case JString(structType)  => DataType.fromJson(structType).asInstanceOf[StructType]
    }, {
      case structType: StructType => JString(structType.json)
    }))

    // define formats for org.json4s.jackson.Serialization
    implicit val formats = DefaultFormats + URISerializer + SturctTypeSerializer

    var stringBuffer = new ListBuffer[String]()

    // create a JSON string from Seq
    objs.foreach(obj => {
      stringBuffer += Serialization.write(obj)
    })

    return stringBuffer.toList
  }

  def WriteToFile(content:Seq[String], filePath: String) : Unit = {
    val df = content.toDF
    df.write.mode(SaveMode.Overwrite).text(filePath);
  }

  def ExportCatalogObjectsToFile(databases: List[CatalogDatabase], tables: List[CatalogTables], partitions: List[CatalogPartitions], stats: List[CatalogStat], outputDirectory: String) : Unit = {
    val jsonStringForDbs = ConvertToJsonStringList(databases)
    WriteToFile(jsonStringForDbs, outputDirectory.trim() + "/databases")
    println("Databases are exported to: " + outputDirectory.trim() + "/databases "+ Calendar.getInstance().getTime())

    val jsonStringForTables = ConvertToJsonStringList(tables)
    WriteToFile(jsonStringForTables, outputDirectory.trim() + "/tables")
    println("Tables are exported to: " + outputDirectory.trim() + "/tables "+ Calendar.getInstance().getTime())

    val jsonStringForParts = ConvertToJsonStringList(partitions)
    WriteToFile(jsonStringForParts, outputDirectory.trim() + "/partitions")
    println("Partitions are exported to: " + outputDirectory.trim() + "/partitions "+ Calendar.getInstance().getTime())

    val jsonStringForStats = ConvertToJsonStringList(stats);
    WriteToFile(jsonStringForStats, outputDirectory.trim() + "/catalogObjectStats")
  }

  def ExportCatalogObjectFromMetadataStore(outputDirecoty: String, databaseNames: String):Unit = {
    val maxObjectCount = 1000

    var dbBuffer = new ListBuffer[CatalogDatabase]()
    var tableBuffer = new ListBuffer[CatalogTables]()
    var partitionBuffer = new ListBuffer[CatalogPartitions]()

    var dbNames = spark.sharedState.externalCatalog.listDatabases()

    var exportedDbName:Seq[String] = Seq()
    if (databaseNames.nonEmpty) {
      exportedDbName = databaseNames.split(";").filter(_.nonEmpty)
    }

    // get databases
    var tableIds = Map[String, Seq[String]]()
    dbNames.foreach( dbName => {
      if (exportedDbName.contains("*") || exportedDbName.contains(dbName)) {
        dbBuffer += spark.sharedState.externalCatalog.getDatabase(dbName)
        val tableNames = spark.sharedState.externalCatalog.listTables(dbName)

        // Update table id map
        tableIds.put(dbName, tableNames)
      }
    })

    println(dbNames.size + " databases get from metastore. "+ Calendar.getInstance().getTime())

    var tableCount = 0;
    var partitionCount = 0;
    for( tableId <- tableIds) {
      var dbName = tableId._1
      var tables = new ListBuffer[CatalogTable]()

      for(tableName <- tableId._2) {
        val table = spark.sharedState.externalCatalog.getTable(dbName, tableName)
        tables += table
        tableCount += 1

        if (table.partitionColumnNames.nonEmpty){
          //org.apache.spark.sql.catalyst.catalog.ExternalCatalogWithListener
          //override def listPartitions(db: String,table: String,partialSpec: Option[CatalogTypes.TablePartitionSpec] = None): scala.Seq[CatalogTablePartition]
          val tablePartitions =  spark.sharedState.externalCatalog.listPartitions(dbName, tableName)
          partitionCount += tablePartitions.size

          if (tablePartitions.nonEmpty) {

            for (group <- tablePartitions.toList.grouped(maxObjectCount)) {
              partitionBuffer += CatalogPartitions(table.identifier.database.get, table.identifier.table, group.toSeq)
            }
          }
        }

        if (tableCount > 0 && tableCount%100 == 0) {
          println(tableCount + " tables get from metastore. "+ Calendar.getInstance().getTime())
          println(partitionCount + " partitions get from metastore. "+ Calendar.getInstance().getTime())
        }
      }

      for (group <- tables.toList.grouped(maxObjectCount)) {
        tableBuffer += CatalogTables(dbName, group)
      }
    }

    println(tableCount + " tables get from metastore. "+ Calendar.getInstance().getTime())
    println(partitionCount + " partitions get from metastore. "+ Calendar.getInstance().getTime())

    // Sum database count
    var statBuffer = new ListBuffer[CatalogStat];
    statBuffer.append(CatalogStat(DatabaseType, dbBuffer.size, None, None))

    // Sum table count
    var totalTableCount = 0;
    tableBuffer.groupBy(tbls => tbls.database).foreach(group => {
      var tblcount = 0;
      group._2.foreach(tbls => {
        tblcount += tbls.tables.size
      })
      statBuffer.append(CatalogStat(TableType, tblcount, Some(group._1), None))
      totalTableCount += tblcount;
    })
    statBuffer.append(CatalogStat(TableType, totalTableCount, None, None))

    // Sum Parititon Count
    var totablPartitionCount = 0;
    partitionBuffer.groupBy(parts => (parts.database, parts.table)).foreach(group => {
      var partCount = 0;
      group._2.foreach(parts => {
        partCount += parts.tablePartitons.size
      })
      statBuffer.append(CatalogStat(PartitionType, partCount, Some(group._1._1), Some(group._1._2)))
      totablPartitionCount += partCount;
    })
    statBuffer.append(new CatalogStat(PartitionType, totablPartitionCount, None, None))

    ExportCatalogObjectsToFile(dbBuffer.toList, tableBuffer.toList, partitionBuffer.toList, statBuffer.toList, outputDirecoty)
  }

}

println("IntermediateFolderPath: " + IntermediateFolderPath + ". " + Calendar.getInstance().getTime())
println("DatabaseNames : " + DatabaseNames + ". " + Calendar.getInstance().getTime())
ExportMetadata.ExportCatalogObjectFromMetadataStore(IntermediateFolderPath, DatabaseNames)

