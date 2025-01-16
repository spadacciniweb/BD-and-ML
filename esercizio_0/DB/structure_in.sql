CREATE DATABASE `BD_and_ML_0` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

use BD_and_ML_0;
create table car (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `height` smallint unsigned DEFAULT NULL,
    `length` smallint unsigned DEFAULT NULL,
    `width` smallint unsigned DEFAULT NULL,
    `driveline_id` tinyint unsigned not null default 1,
    `engine_type` VARCHAR(255),
    `hybrid` bool not null default 1,
    `forward_gears` tinyint unsigned not null,
    `trasmission` varchar(255),
    `fuel_type_id` tinyint unsigned not null,
    `fuel_city` varchar(10),
    `fuel_highway` varchar(10),
    `classification_id` tinyint unsigned not null,
    `identification_key` varchar(255) not null,
    `make_id` tinyint unsigned not null,
    `model_year` varchar(50) not null,
    `year` char(4) not null,
    `horsepower` varchar(8) not null,
    `torque` varchar(8) not null,
  `creazione` datetime DEFAULT current_timestamp(),
  `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
    CONSTRAINT `car_idfk_1` FOREIGN KEY (`driveline_id`) REFERENCES `driveline` (`id`),
    CONSTRAINT `car_idfk_2` FOREIGN KEY (`fuel_type_id`) REFERENCES `fuel_type` (`id`),
    CONSTRAINT `car_idfk_3` FOREIGN KEY (`classification_id`) REFERENCES `classification` (`id`),
    CONSTRAINT `car_idfk_4` FOREIGN KEY (`make_id`) REFERENCES `make` (`id`)
);

"Dimensions.Height","Dimensions.Length","Dimensions.Width","Engine Information.Driveline","Engine Information.Engine Type","Engine Information.Hybrid","Engine Information.Number of Forward Gears","Engine Information.Transmission","Fuel Information.City mpg","Fuel Information.Fuel Type","Fuel Information.Highway mpg","Identification.Classification","Identification.ID","Identification.Make","Identification.Model Year","Identification.Year","Engine Information.Engine Statistics.Horsepower","Engine Information.Engine Statistics.Torque"

create table driveline (
    `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
    `description` varchar(50) not null,
  PRIMARY KEY (`id`)
);
create table fuel_type (
    `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
    `description` varchar(50) not null,
  PRIMARY KEY (`id`)
);
create table classification (
    `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
    `description` varchar(50) not null,
  PRIMARY KEY (`id`)
);
create table make (
    `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
    `description` varchar(50) not null,
  PRIMARY KEY (`id`)
);
