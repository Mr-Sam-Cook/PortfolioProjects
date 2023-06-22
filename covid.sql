

SELECT * 
FROM CovidDeaths
ORDER BY 3,4 

--SELECT * 
--FROM CovidVaccinations
--ORDER BY 3,4


--Select Data that we are going to use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

--TOTAL CASES vs TOTAL DEATHS
--Likelihood of dying if you get covid in 2021 in South Africa
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE Location = 'South Africa'
Order by 1,2

--Looking at Total Cases vs Population
SELECT Location, date, total_cases, population, (total_cases/population) * 100 AS CasesPercentage
FROM CovidDeaths
WHERE location = 'South Africa' AND total_cases IS NOT NULL
ORDER BY 1,2

--Looking at countries with highest infection rate compared to pop
SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 AS PercentInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY 4 desc

--Looking at countries with highest infection rate compared to pop
SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 AS PercentInfected
FROM CovidDeaths
WHERE location = 'South Africa' AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY 4 desc

--Highest death count per population (Country)
SELECT Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by Location 
ORDER by TotalDeathCount desc

--Breaking things up by continent

--Continents with the highest death count
--Highest death count per population (Continent)
SELECT Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is null
GROUP by Location 
ORDER by TotalDeathCount desc

--Highest death count per population (Continent)
SELECT continent , MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by continent 
ORDER by TotalDeathCount desc


--GLOBAL NUMBERS
SELECT Date, SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeath,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--total_deaths --(total_deaths/total_cases)* 100 as DeathPercentage
FROM CovidDeaths
WHERE Continent is not null
GROUP BY date 
ORDER BY 1,2

-- Remove Date to get totals as a singular 
SELECT SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeath,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--total_deaths --(total_deaths/total_cases)* 100 as DeathPercentage
FROM CovidDeaths
WHERE Continent is not null
--GROUP BY date 
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations

SELECT * 
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date

SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date

SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date
WHERE VAC.continent is not null AND DEA.new_vaccinations is not null
ORDER BY 1,2,3


SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations,
SUM(cast(VAC.new_vaccinations as int)) OVER (Partition by DEA.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date
WHERE VAC.continent is not null AND DEA.new_vaccinations is not null
ORDER BY 1,2,3

--USE CTE

WITH PopvsVac(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations,
SUM(cast(VAC.new_vaccinations as int)) OVER (Partition by DEA.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date
WHERE VAC.continent is not null AND DEA.new_vaccinations is not null
--ORDER BY 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentageVaccinated
FROM PopvsVac

--Temp Table
DROP TABLE IF EXISTS #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopVaccinated
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations,
SUM(cast(VAC.new_vaccinations as int)) OVER (Partition by DEA.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date
WHERE VAC.continent is not null AND DEA.new_vaccinations is not null
ORDER BY 1,2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentageVaccinated
FROM #PercentPopVaccinated

--CREATE VIEW TO STORE DATA FOR LATER VISUALISATIONS

CREATE VIEW PercentPopVaccinated AS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, DEA.new_vaccinations,
SUM(cast(VAC.new_vaccinations as int)) OVER (Partition by DEA.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations VAC
INNER JOIN CovidDeaths DEA
on
VAC.Location = DEA.Location and 
VAC.Date = DEA.Date
WHERE VAC.continent is not null AND DEA.new_vaccinations is not null
--ORDER BY 1,2,3

SELECT * FROM 
PercentPopVaccinated
