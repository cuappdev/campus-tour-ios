const fs = require("fs");
const DATA_FILE_PATH = "locations-raw.json";
const CLEAN_FILE_PATH = "locations-clean.json";

const rawLocations = JSON.parse(fs.readFileSync(DATA_FILE_PATH));

const importantLocationNames = [
    "Day Hall",
    "Sage Chapel",
    "The Cornell Store",
    "Willard Straight Hall",
    "McGraw Tower",
    "Uris Library",
    "Kroch Library",
    "Goldwin Smith Hall",
    "Klarman Hall",
    "Lincoln Hall",
    "Sibley Hall",
    "Johnson Museum of Art",
    "Noyes Community and Recreation Center",
    "Robert Purcell Community Center",
    "Robert J & Helen Appel Commons",
    "Helen Newman Hall",
    "Physical Sciences Building",
    "Rockefeller Hall",
    "Bailey Hall",
    "Caldwell Hall",
    "Martha Van Rensselaer Hall",
    "Human Ecology Building",
    "Warren Hall",
    "Mann Library",
    "Kennedy Hall",
    "Stocking Hall",
    "Botanic Gardens",
    "Ives Hall",
    "Barton Hall",
    "Teagle Hall",
    "Schoellkopf Field",
    "Bill and Melinda Gates Hall",
    "Duffield Hall",
    "Statler Hall",
    "Statler Hotel & J. Willard Marriott Executive Education Center",
    "Anabel Taylor Hall",
    "Cornell Health",
    "Vet Education Center",
    "James Law Auditorium",
//grad school of management is missing.
];

const cleanLocations = rawLocations.locations
      .map(loc => ({
          name: loc.Name,
          latitude: loc.Lat,
          longitude: loc.Lng
      }))
      .filter(loc => importantLocationNames.includes(loc.name));

fs.writeFileSync(CLEAN_FILE_PATH, JSON.stringify(cleanLocations, null, ' '));
