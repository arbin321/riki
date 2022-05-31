-----a
------------1
create database flights
go
use database [flights]
go
create table airport_tbl(
	id int identity (1,1) primary key,
	country varchar(30) not null,
	city varchar(30) not null
)
go
create table airplanes_tbl(
	id int identity (100,10) primary key,
	places int not null
)
go
create table flightPlannings_tbl(
	id int identity (1,1) primary key,
	[sourceId] int foreign key references airport_tbl not null,
	[destId] int foreign key references airport_tbl not null,
	fromDate date not null,
	toDate date ,
	durationOfFlight int not null,

)
go
create table flightsDays_tbl(
	id int identity (1,1) primary key,
	planningFlightId int foreign key references flightPlannings_tbl not null,
	[Day] int not null,
	leavingTime time not null,
	[airplaneId] int foreign key references airplanes_tbl not null,
)
go
create table actualFlights_tbl(
	id int identity (1,1) primary key,
	[flightsDayId] int foreign key references flightsDays_tbl not null,
	[date] date not null,
	leavingTime time not null,
	arrivalTime time not null,
	Passengers int not null	
)

insert into airport_tbl values( 'Tel-Aviv','Israel')
insert into airport_tbl values( 'New York','U.S')
insert into airport_tbl values( 'Egypt' ,'Cairo')
insert into airplanes_tbl values( 120)
insert into airplanes_tbl values( 900)
insert into airplanes_tbl values( 100)
insert into airplanes_tbl values( 1523)
insert into flightPlannings_tbl values( 1 ,2,'01-03-2022','02-03-2022',12)
insert into flightPlannings_tbl values( 1 ,2,'02-04-2022','03-04-2022',12)
insert into flightPlannings_tbl values( 2 ,1,'2-04-2022','3-04-2022',12)
insert into flightPlannings_tbl values( 1 ,3,'02-04-2022','03-04-2022',12)
insert into flightPlannings_tbl values( 2 ,3,'30-04-2022','30-04-2022',1)
insert into flightPlannings_tbl values( 2 ,3,'2-04-2022','3-04-2022',1)
insert into flightPlannings_tbl values( 1 ,2,'02-04-2022','03-04-2022',12)
insert into flightPlannings_tbl values( 3 ,2,'2-5-2022','3-05-2022',12)
insert into flightsDays_tbl values( 1 ,1,'14:30',100)
insert into flightsDays_tbl values( 2 ,4,'14:30',110)
insert into flightsDays_tbl values( 6 ,1,'17:30',120)
insert into flightsDays_tbl values( 11,2,'18:30',110)
insert into flightsDays_tbl values( 1 ,3,'16:30',100)
insert into flightsDays_tbl values(14 ,5,'14:30',120)
insert into actualFlights_tbl values(1 ,'10-2-2022','14:30','20:30',120)
insert into actualFlights_tbl values(1 ,'4-22-2022','14:30','20:30',120)
insert into actualFlights_tbl values(1 ,'4-28-2022','14:30','20:30',120)
insert into actualFlights_tbl values(8 ,'4-2-2022','13:30','20:30',120)
insert into actualFlights_tbl values(9 ,'4-22-2022','15:00','12:31',120)
insert into actualFlights_tbl values(10 ,'4-28-2022','15:30','12:30',120)
insert into actualFlights_tbl values(10 ,'4-28-2022','15:30','12:30',10)

select *
from actualFlights_tbl
-----------2
go
create view sourceDestFlights
as
select dca.city+' '+dca.country as dest,sca.city+' '+sca.country as source,count
from (select count(af.id) as count,fp.destId,fp.sourceId
	from actualFlights_tbl af 
		join flightsDays_tbl fd on af.flightsDayId=fd.id 
		join flightPlannings_tbl fp on fd.planningFlightId=fp.id 	
	where year(af.date)=year(getdate()) and  month(af.date)=month(getdate())-1
	group by fp.destId,fp.sourceId)all1
		left join airport_tbl dca on all1.destId=dca.id
		left join airport_tbl sca on all1.sourceId=sca.id

select * from sourceDestFlights

----b
----------1
create table cancellationFlights_tbl(
id int identity(1,1) primary key,
codeFlight int foreign key references actualFlights_tbl not null,
Passengers int ,
emptyPlace int ,
date date ,
leavingTime time
)
go
create or alter proc psAddTocancel_tbl
(@codeFlight int,@passengers int, @date date)
as
begin
insert into cancellationFlights_tbl values (@codeFlight,@passengers,
					(select apl.places-@passengers as emptyPlace
					from actualFlights_tbl acf 
						join flightsDays_tbl fd on acf.flightsDayId=fd.id 
						join airplanes_tbl apl on fd.airplaneId=apl.id	
					where acf.id=@codeFlight and acf.Passengers=@passengers and acf.date=@date),
					@date,(select acf.leavingTime as leavingTime 
					from actualFlights_tbl acf 
						join flightsDays_tbl fd on acf.flightsDayId=fd.id 
						join airplanes_tbl apl on fd.airplaneId=apl.id	
					where acf.id=@codeFlight and acf.Passengers=@passengers and acf.date=@date)
					)
end
exec psAddTocancel_tbl 2,120,'10-02-2022'
go
create or alter trigger MaybeCancelFlight on actualFlights_tbl
for insert
as
begin
declare @codeFlight int=-1,@passengers int, @date date
select @codeFlight=ins.id,@passengers=ins.Passengers,@date=ins.date
	from inserted ins join flightsDays_tbl fd on ins.flightsDayId=fd.id 
	join airplanes_tbl apl on fd.airplaneId=apl.id
	where apl.places-ins.Passengers>30
if(@codeFlight!=-1)
begin
exec psAddTocancel_tbl @codeFlight,@passengers,@date
print('psAddTocancel_tbl work')
end
end
select *
from cancellationFlights_tbl

-----2
go
create or alter proc psSourceDestFlightsByMonth
(@month date)
as
select dca.city+' '+dca.country as dest,sca.city+' '+sca.country as source,count
from (select count(af.id) as count,fp.destId,fp.sourceId
	from actualFlights_tbl af 
		join flightsDays_tbl fd on af.flightsDayId=fd.id 
		join flightPlannings_tbl fp on fd.planningFlightId=fp.id 	
	where year(af.date)=year(@month) and  month(af.date)=month(@month)
	group by fp.destId,fp.sourceId)all1
		left join airport_tbl dca on all1.destId=dca.id
		left join airport_tbl sca on all1.sourceId=sca.id

exec  psSourceDestFlightsByMonth '4-02-2022'
go
declare @month date= '4-02-2022'
select *
from  (select dca.city+'-'+sca.city as counry,count as count
	from (select count(af.id) as count,fp.destId,fp.sourceId
		from actualFlights_tbl af 
			join flightsDays_tbl fd on af.flightsDayId=fd.id 
			join flightPlannings_tbl fp on fd.planningFlightId=fp.id 	
		where year(af.date)=year(@month) and  month(af.date)=month(@month)
		group by fp.destId,fp.sourceId)all1
			left join airport_tbl dca on all1.destId=dca.id
			left join airport_tbl sca on all1.sourceId=sca.id)a 

go
declare @PivotHeader nvarchar(max)
set @PivotHeader = ' '
select     @PivotHeader=@PivotHeader+ ' ['+ country+'],'
from (select dca.city+'-'+sca.city as country,count as count
	from (select count(af.id) as count,fp.destId,fp.sourceId
		from actualFlights_tbl af 
			join flightsDays_tbl fd on af.flightsDayId=fd.id 
			join flightPlannings_tbl fp on fd.planningFlightId=fp.id 	
		group by fp.destId,fp.sourceId)all1
			left join airport_tbl dca on all1.destId=dca.id
			left join airport_tbl sca on all1.sourceId=sca.id)a
group by country
set @PivotHeader = substring(@PivotHeader,0,len(@PivotHeader))
print(@PivotHeader)
declare @pivotQuery nvarchar(max)
set  @pivotQuery = '
SELECT * FROM ((select dca.city+''-''+sca.city as country,count as count,cast(all1.month as varchar(20))+''-''+cast(all1.year as varchar(20))as month
		from (select count(af.id) as count,fp.destId,fp.sourceId,year(af.date) as year,month(af.date) as month
			from actualFlights_tbl af 
				join flightsDays_tbl fd on af.flightsDayId=fd.id 
				join flightPlannings_tbl fp on fd.planningFlightId=fp.id 
			group by year(af.date),month(af.date),fp.destId,fp.sourceId)all1
			left join airport_tbl dca on all1.destId=dca.id
			left join airport_tbl sca on all1.sourceId=sca.id)) piv
pivot(sum(count) for country in( '+@PivotHeader+')) P'
execute (@pivotQuery) 

--SELECT * FROM ((select dca.city+'-'+sca.city as country,count as count,cast(all1.year+'-'+all1.month as varchar(20)) as month
--		from (select count(af.id) as count,fp.destId,fp.sourceId,year(af.date) as year,month(af.date) as month
--			from actualFlights_tbl af 
--				join flightsDays_tbl fd on af.flightsDayId=fd.id 
--				join flightPlannings_tbl fp on fd.planningFlightId=fp.id 
--			group by year(af.date),month(af.date),fp.destId,fp.sourceId)all1
--			left join airport_tbl dca on all1.destId=dca.id
--			left join airport_tbl sca on all1.sourceId=sca.id)) piv
--pivot(sum(count) for country in( [Cairo-U.S], [Israel-U.S], [U.S-Israel])) P

----3
----לא הבנתי!!
----4
go
create or alter function fTimeDiff
(@time1 time,@time2 time)
returns int
as
begin
return datediff(MINUTE,@time1,@time2)
end
declare @time1 time='14:35',@time2 time='14:40'
print dbo.fTimeDiff(@time1,@time2)

go
create or alter function fTableByAirport
(@idAirport int)
returns table
as
return 
--go
--declare @idAirport int=1
(select acf.id as codeActuly,acf.date [date],case 
when fp.destId=@idAirport then 'dest'
when fp.sourceId=@idAirport then 'source'
end as [descurb],acf.leavingTime,dbo.fTimeDiff(acf.leavingTime,fd.leavingTime) as [diffTime],case 
when dbo.fTimeDiff(acf.leavingTime,fd.leavingTime)=0 then 0
when dbo.fTimeDiff(acf.leavingTime,fd.leavingTime)>0 then 1
else -1
end as [statusTime]
from actualFlights_tbl acf 
	join flightsDays_tbl fd on acf.flightsDayId=fd.id 
	join flightPlannings_tbl fp on fd.planningFlightId=fp.id 
where fp.sourceId=@idAirport or fp.destId=@idAirport)
go
declare @airplance int=3
select * from  dbo.fTableByAirport(@airplance)
