set search_path TO "YrkesCo";

select * from adress;

select * from antagen_student;

select * from beviljad_omgång;

select * from fastanställd;

select * from fristående_kurs;

select * from fristående_student;

select * from företag;

select * from klass;

select * from konsult;

select * from konsultbolag;

select * from kurs;

select * from kursbetyg;

select * from kursprogram;

select * from kurstillfälle;

select * from ledningsföretag;

select * from ledningsgrupp;

select * from ledningspersonal;

select * from ledningstudent;

select * from personal;

select * from personuppgift;

select * from program;

select * from protokoll;

select * from skola;

select * from skolpersonal;

select * from skolprogram;

select * from stad;

select * from student;

select * from yrkesroll;

-- Vilka som ingår i Ledningsgrupperna 
SELECT lg.program_id,sk.skolnamn ,p.förnamn as personal, y.titel, s.förnamn || ' ' || s.efternamn as student, f.företag_namn, f.representant
from ledningsgrupp lg
inner join ledningspersonal lp on lg.ledningsgrupp_id = lp.ledningsgrupp_id
inner join personal p on lp.personal_id = p.personal_id
inner join ledningstudent ls on lg.ledningsgrupp_id = ls.ledningsgrupp_id
inner join student s on ls.student_id = s.student_id
inner join yrkesroll y on p.yrkes_id = y.yrkes_id
inner join skola sk on lg.skol_id = sk.skol_id
inner join ledningsföretag lf on lg.ledningsgrupp_id = lf.ledningsgrupp_id
inner join företag f on lf.företag_org_nummer = f.företag_org_nummer
order by lg.program_id;


-- Utbildningsledare som ansvarar för vilka klasser
SELECT bo.program_id || bo.år as klass, p.förnamn ||' '|| p.efternamn as Utbildningsledare, s.skolnamn
FROM personal p
inner join klass kl on p.personal_id = kl.personal_id
inner join yrkesroll y on p.yrkes_id = y.yrkes_id
inner join beviljad_omgång bo on kl.bo_id = bo.bo_id
inner join skola s on kl.skol_id = s.skol_id 
inner join "program" p2 on bo.program_id = p2.program_id 
where y.yrkes_id = 1;


-- Vilka Studenter som bor på vilka adresser med deras personnummer
select s.förnamn, s.efternamn,pu.personnummer ,a.gatuadress, st.stad
from student s
inner join personuppgift pu on s.pu_id = pu.pu_id
inner join adress a on  pu.adress_id = a.adress_id
inner join stad st on a.stad_id = st.stad_id 





-- I vilken stad pluggar studenterna 
SELECT
  s.förnamn,
  s.efternamn,
  st.stad
FROM student s
JOIN skola sk ON s.skol_id = sk.skol_id
JOIN adress a ON sk.adress_id = a.adress_id
JOIN stad st ON a.stad_id = st.stad_id;


-- Visa studenters betyg
SELECT
  s.förnamn,
  s.efternamn,
  k.kursnamn,
  kb.betyg
FROM student s
JOIN kursbetyg kb ON s.student_id = kb.student_id
JOIN kurs k ON kb.kurskod = k.kurskod;



-- Vilken personal är kopplad till vilka kurstillfällen
SELECT
  p.förnamn,
  p.efternamn,
  y.titel AS yrkesroll,
  k.kursnamn
FROM personal p
JOIN yrkesroll y ON p.yrkes_id = y.yrkes_id
JOIN kurstillfälle kt ON p.personal_id = kt.personal_id
JOIN kurs k ON kt.kurskod = k.kurskod;



-- Studenter och vilket program de går
SELECT
  s.förnamn,
  s.efternamn,
  p.programnamn
FROM student s
JOIN antagen_student ast ON s.student_id = ast.student_id
JOIN klass kl ON ast.klass_id = kl.klass_id
JOIN beviljad_omgång bo ON kl.bo_id = bo.bo_id
JOIN program p ON bo.program_id = p.program_id;


-- Vilken yrkesroll har personalen
SELECT
  p.förnamn || ' ' || p.efternamn as personal,
  y.titel AS yrkesroll
FROM personal p
JOIN yrkesroll y ON p.yrkes_id = y.yrkes_id;


-- Hämta alla skolor och deras adresser
SELECT
  s.skolnamn,
  a.gatuadress,
  a.postnummer
FROM skola s
JOIN adress a ON s.adress_id = a.adress_id;



-- Hämta studenter och vilken skola de tillhör
SELECT
  st.förnamn,
  st.efternamn,
  sk.skolnamn
FROM student st
JOIN skola sk ON st.skol_id = sk.skol_id;



-- Hämta utbildare och de kurser de undervisar
SELECT
  p.förnamn,
  p.efternamn,
  k.kursnamn
FROM personal p
JOIN kurstillfälle kt ON p.personal_id = kt.personal_id
JOIN kurs k ON kt.kurskod = k.kurskod
order by k.kursnamn;



-- Alla antagna studenter, deras klass, utbildningsledare och program
SELECT
  st.förnamn || ' ' ||st.efternamn AS student,
  kl.klass_id,
  p.förnamn AS ledare_förnamn,
  p.efternamn AS ledare_efternamn,
  pr.programnamn
FROM antagen_student ast
JOIN klass kl ON ast.klass_id = kl.klass_id
JOIN personal p ON kl.personal_id = p.personal_id
JOIN beviljad_omgång bo ON kl.bo_id = bo.bo_id
JOIN program pr ON bo.program_id = pr.program_id
JOIN student st ON ast.student_id = st.student_id;


-- Konsulter, vilket företag de tillhör och vilka klasser de undervisar
SELECT
  p.förnamn || ' ' || p.efternamn as konsult,
  k.timpris,
  kb.bolagsnamn,
  ku.kursnamn
FROM konsult k
JOIN personal p ON k.personal_id = p.personal_id
JOIN konsultbolag kb ON k.org_nummer = kb.org_nummer
JOIN kurstillfälle kt ON p.personal_id = kt.personal_id
JOIN kurs ku ON kt.kurskod = ku.kurskod;


-- Konsulter, vilket företag de tillhör och vilka klasser de undervisar
SELECT
  p.förnamn || ' ' || p.efternamn AS konsult,
  k.timpris,
  kb.bolagsnamn,
  STRING_AGG(ku.kursnamn, ', ') AS kurser
FROM konsult k
JOIN personal p ON k.personal_id = p.personal_id
JOIN konsultbolag kb ON k.org_nummer = kb.org_nummer
JOIN kurstillfälle kt ON p.personal_id = kt.personal_id
JOIN kurs ku ON kt.kurskod = ku.kurskod
GROUP BY p.förnamn, p.efternamn, k.timpris, kb.bolagsnamn;


