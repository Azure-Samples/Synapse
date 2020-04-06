
CREATE TABLE SearchLog(
   id           INTEGER  NOT NULL
  ,time         DATETIME  NOT NULL
  ,market       VARCHAR(16) NOT NULL
  ,searchtext   VARCHAR(255) NOT NULL
  ,latency      INTEGER  NOT NULL
  ,links        VARCHAR(255) NOT NULL
  ,clickedlinks VARCHAR(255)
);

INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (399266,'2019-10-15T11:53:04Z','en-us','how to make nachos',73,'www.nachos.com;www.wikipedia.com',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (382045,'2019-10-15T11:53:25Z','en-gb','best ski resorts',614,'skiresorts.com;ski-europe.com;www.travelersdigest.com/ski_resorts.htm','ski-europe.com;www.travelersdigest.com/ski_resorts.htm');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (382045,'2019-10-16T11:53:42Z','en-gb','broken leg',74,'mayoclinic.com/health;webmd.com/a-to-z-guides;mybrokenleg.com;wikipedia.com/Bone_fracture','mayoclinic.com/health;webmd.com/a-to-z-guides;mybrokenleg.com;wikipedia.com/Bone_fracture');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (106479,'2019-10-16T11:53:10Z','en-ca','south park episodes',24,'southparkstudios.com;wikipedia.org/wiki/Sout_Park;imdb.com/title/tt0121955;simon.com/mall','southparkstudios.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (906441,'2019-10-16T11:54:18Z','en-us','cosmos',1213,'cosmos.com;wikipedia.org/wiki/Cosmos:_A_Personal_Voyage;hulu.com/cosmos',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (351530,'2019-10-16T11:54:29Z','en-fr','microsoft',241,'microsoft.com;wikipedia.org/wiki/Microsoft;xbox.com',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (640806,'2019-10-16T11:54:32Z','en-us','wireless headphones',502,'www.amazon.com;reviews.cnet.com/wireless-headphones;store.apple.com','www.amazon.com;store.apple.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (304305,'2019-10-16T11:54:45Z','en-us','dominos pizza',60,'dominos.com;wikipedia.org/wiki/Domino''s_Pizza;facebook.com/dominos','dominos.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (460748,'2019-10-16T11:54:58Z','en-us','yelp',1270,'yelp.com;apple.com/us/app/yelp;wikipedia.org/wiki/Yelp,_Inc.;facebook.com/yelp','yelp.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (354841,'2019-10-16T11:59:00Z','en-us','how to run',610,'running.about.com;ehow.com;go.com','running.about.com;ehow.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (354068,'2019-10-16T12:00:07Z','en-mx','what is sql',422,'wikipedia.org/wiki/SQL;sqlcourse.com/intro.html;wikipedia.org/wiki/Microsoft_SQL','wikipedia.org/wiki/SQL');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (674364,'2019-10-16T12:00:21Z','en-us','mexican food redmond',283,'eltoreador.com;yelp.com/c/redmond-wa/mexican;agaverest.com',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (347413,'2019-10-16T12:11:34Z','en-gr','microsoft',305,'microsoft.com;wikipedia.org/wiki/Microsoft;xbox.com',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (848434,'2019-10-16T12:12:14Z','en-ch','facebook',10,'facebook.com;facebook.com/login;wikipedia.org/wiki/Facebook','facebook.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (604846,'2019-10-16T12:13:18Z','en-us','wikipedia',612,'wikipedia.org;en.wikipedia.org;en.wikipedia.org/wiki/Wikipedia','wikipedia.org');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (840614,'2019-10-16T12:13:41Z','en-us','xbox',1220,'xbox.com;en.wikipedia.org/wiki/Xbox;xbox.com/xbox360','xbox.com/xbox360');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (656666,'2019-10-16T12:15:19Z','en-us','hotmail',691,'hotmail.com;login.live.com;msn.com;en.wikipedia.org/wiki/Hotmail',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (951513,'2019-10-16T12:17:37Z','en-us','pokemon',63,'pokemon.com;pokemon.com/us;serebii.net','pokemon.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (350350,'2019-10-16T12:18:17Z','en-us','wolfram',30,'wolframalpha.com;wolfram.com;mathworld.wolfram.com;en.wikipedia.org/wiki/Stephen_Wolfram',NULL);
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (641615,'2019-10-16T12:19:21Z','en-us','kahn',119,'khanacademy.org;en.wikipedia.org/wiki/Khan_(title);answers.com/topic/genghis-khan;en.wikipedia.org/wiki/Khan_(name)','khanacademy.org');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (321065,'2019-10-16T12:20:19Z','en-us','clothes',732,'gap.com;overstock.com;forever21.com;footballfanatics.com/college_washington_state_cougars','footballfanatics.com/college_washington_state_cougars');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (651777,'2019-10-16T12:20:49Z','en-us','food recipes',183,'allrecipes.com;foodnetwork.com;simplyrecipes.com','foodnetwork.com');
INSERT INTO SearchLog(id,time,market,searchtext,latency,links,clickedlinks) VALUES (666352,'2019-10-16T12:21:16Z','en-us','weight loss',630,'en.wikipedia.org/wiki/Weight_loss;webmd.com/diet;exercise.about.com','webmd.com/diet');

