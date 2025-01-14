CREATE DATABASE `BD_and_ML_0` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
create user <USER>@localhost identified by '<PASSWORD>';
grant all privileges on BD_and_ML_0.* to <USER>@localhost;
