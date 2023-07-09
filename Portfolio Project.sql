--Update the column to replace empty values by NUll to avoid Inconsistance in data
update Portfolio_project..CovidDeaths$ 
set continent = NULL
where continent = ''

select *
from Portfolio_project..CovidDeaths$ 
where Continent is not NULL and location is not NULL

-- TO change the coloumn type to avoid any calculation errors
ALTER TABLE Portfolio_project..CovidDeaths$
ALTER COLUMN total_deaths Float

ALTER TABLE Portfolio_project..CovidDeaths$
ALTER COLUMN total_cases Float

-- likelyhood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100  as DeathPercentage
from Portfolio_project..CovidDeaths$
where total_deaths is not null and location like '%states'
order by 1,2

--looking at total case vs Population
select location, date,population, total_cases, (total_cases/population) * 100 as Affected_People_percentage
from Portfolio_project..CovidDeaths$
where total_deaths is not null and location like '%states'
order by 1,2

--Country with Higher Infection Rate
select location,population, max(total_cases) as Highest_Infection_count, MAX((total_cases/population)) * 100 as Affected_People_percentage
from Portfolio_project..CovidDeaths$
Group by location, population 
order by Affected_People_percentage desc

--Showing Countries with highest death Count Per populated
select location, MAX(total_deaths) as death_Count
from Portfolio_project..CovidDeaths$
where Continent is not NULL and location is not NULL
Group by location
order by death_Count desc

--Showing Continent with highest death Count Per populated
select Continent, MAX(total_deaths) as death_Count
from Portfolio_project..CovidDeaths$
where Continent is not NULL
Group by Continent
order by death_Count desc

--Global Numbers
select  date, sum(new_cases) as TOTAL_CASES, sum(new_deaths) as TOTAL_DEATHS,  sum(TOTAL_DEATHS) / sum(TOTAL_CASES) * 100 as New_death_percentage
from Portfolio_project..CovidDeaths$
where TOTAL_CASES is not NULL and TOTAL_DEATHS is not NULL
Group by date 
order by TOTAL_CASES desc

--TOTAL Numbers
select sum(new_cases) as TOTAL_CASES, sum(new_deaths) as TOTAL_DEATHS,  sum(TOTAL_DEATHS) / sum(TOTAL_CASES) * 100 as New_death_percentage
from Portfolio_project..CovidDeaths$
where TOTAL_CASES is not NULL and TOTAL_DEATHS is not NULL  


-- COOVID VACCINE
select *
from Portfolio_project..CovidVacine$
where Continent is not NULL and location is not NULL

--JOINING BOTH TABLES

select *
from Portfolio_project..CovidDeaths$
JOIN Portfolio_project..CovidVacine$
on Portfolio_project..CovidDeaths$.location = Portfolio_project..CovidVacine$.location
	and Portfolio_project..CovidDeaths$.date = Portfolio_project..CovidVacine$.date
where Portfolio_project..CovidDeaths$.continent is not NULL