select *
from konten
where konten.Statistik not in (11, 12, 13, 14, 15, 16, 17, 18, 19, 231, 232, 234, 235, 236, 237, 241, 242, 243, 244, 245, 246, 247, 248, 249, 251, 253, 254, 3, 41, 42, 43, 44, 45, 46, 47, 51, 52, 53, 54, 55, 56, 57, 58, 59, 61, 62, 63, 64, 65, 66, 67, 68, 71, 72, 73, 81, 82, 84, 85, 86, 87, 88, 99)
order by Sortpos