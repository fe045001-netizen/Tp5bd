USE bibliotheque;
SELECT COUNT(*) AS total_abonnes
FROM abonne;
SELECT AVG(nb) AS moyenne_emprunts
FROM (
  SELECT COUNT(*) AS nb
  FROM emprunt
  GROUP BY abonne_id
) AS sous;

SELECT AVG(prix_unitaire) AS prix_moyen
FROM ouvrage;

SELECT abonne_id, COUNT(*) AS nbre
FROM emprunt
GROUP BY abonne_id;

SELECT auteur_id, COUNT(*) AS total_ouvrages
FROM ouvrage
GROUP BY auteur_id;

DESCRIBE emprunt;
SELECT a.nom, COUNT(e.ouvrage_id) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT auteur_id, COUNT(*) AS total_ouvrages
FROM ouvrage
GROUP BY auteur_id
HAVING total_ouvrages > 5;

SELECT a.nom, COUNT(e.id) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT a.nom, COUNT(*) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT a.nom, COUNT(e.ouvrage_id) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT 
    ROUND(
        COUNT(CASE WHEN e.ouvrage_id IS NOT NULL THEN 1 END) * 100 
        / COUNT(DISTINCT o.id), 2
    ) AS pct_empruntes
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id;

SELECT a.nom, COUNT(*) AS nbre_emprunts
FROM abonne a
JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom
ORDER BY nbre_emprunts DESC
LIMIT 3;

WITH stats AS (
    SELECT 
        o.auteur_id, 
        COUNT(e.ouvrage_id) AS emprunts,  -- correction ici
        COUNT(DISTINCT o.id) AS ouvrages
    FROM ouvrage o
    LEFT JOIN emprunt e ON e.ouvrage_id = o.id
    GROUP BY o.auteur_id
)
SELECT 
    s.auteur_id, 
    s.emprunts / s.ouvrages AS moyenne
FROM stats s
WHERE s.emprunts / s.ouvrages > 2;

SHOW INDEX FROM emprunt;

CREATE INDEX idx_emprunt_abonne ON emprunt(abonne_id);

EXPLAIN
SELECT a.nom, COUNT(*) AS emprunts
FROM abonne a
LEFT JOIN emprunt e ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT 
    DAYOFWEEK(date_debut) AS jour_semaine,
    COUNT(*) / COUNT(DISTINCT date_debut) AS moyenne_emprunts
FROM emprunt
GROUP BY jour_semaine;
SELECT 
    MONTH(date_debut) AS mois,
    COUNT(*) AS total_emprunts
FROM emprunt
WHERE YEAR(date_debut) = 2025
GROUP BY mois
ORDER BY mois;

-- Liste des ouvrages jamais empruntés
SELECT o.titre
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
WHERE e.ouvrage_id IS NULL;

-- Nombre d'ouvrages jamais empruntés
SELECT COUNT(*) AS nb_ouvrages_non_empruntes
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
WHERE e.ouvrage_id IS NULL;
