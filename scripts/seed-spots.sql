-- Run this once in Supabase SQL Editor (Project bmlesyzadmsfbrgczwgu)

create table if not exists public.spots (
  id bigint primary key,
  lat double precision not null,
  lon double precision not null,
  name text not null,
  status text not null default 'open',
  price text,
  hours text,
  pay text,
  type text,
  conf text
);

alter table public.spots enable row level security;

drop policy if exists "Public read access" on public.spots;
create policy "Public read access"
  on public.spots for select
  using (true);

truncate table public.spots;

insert into public.spots (id, lat, lon, name, status, price, hours, pay, type, conf) values
(1, 18.9258758, 72.820559, 'NCPA Parking', 'limited', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open during NCPA events', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(2, 18.9510532, 72.7965089, 'BMC Pay And Park', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(3, 18.9719595, 72.8045352, 'Breach Candy Hospital Trust Parking', 'open', 'Valet parking at nominal price', 'Open 24h', 'Not specified', 'Institutional parking', 'Corroborated · seed data'),
(4, 18.92786213, 72.83165317, 'Kala Ghoda statue parking', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(5, 18.93211936, 72.83161876, 'Paid Parking BMC (Flora Fountain)', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(6, 18.94713832, 72.83357923, 'Brihanmumbai Municipal Corporation Paid Parking', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(7, 19.09865224, 72.82750068, 'Juhu Beach Parking', 'open', 'Rs.65/hr (car)', 'Open 24h', 'Card', 'Surface lot', 'Corroborated · seed data'),
(8, 19.05609842, 72.85298225, 'MMRDA parking (C-32, BKC)', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(9, 18.93256726, 72.8283988, 'Public Parking', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(10, 18.9449326, 72.8343746, 'Pay and Park - Car parking (CSTM)', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(11, 19.0618317, 72.8993605, 'Pay & Park', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(12, 19.281433, 72.8567432, 'Mira Road Station Pay N Park', 'open', '2W: Rs 20 (12 hrs)', 'Open 24h', 'Not specified', 'Bike-only parking', 'Corroborated · seed data'),
(13, 18.9956388, 72.8234161, 'Phoenix Mills Parking Lot', 'open', 'Rs.75 (first 2 hours)', 'Open daily 11:00 AM – 12:00 AM (midnight)', 'Not specified', 'Multilevel parking', 'Corroborated · seed data'),
(14, 18.97723972, 72.81112626, 'Heera Panna Area Parking', 'open', 'Rs.30/hr (2-wheeler)', '10:00 AM – 10:00 PM (shopping centre parking hours)', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(15, 19.0659763, 72.869862, 'Public Car Park Lot near US Consulate', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(16, 19.05942, 72.862928, 'MMRDA parking', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(17, 19.0624389, 72.8612165, 'MMRDA Open Car Park', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(18, 19.0657602, 72.8592259, 'Pay and Park', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(19, 18.9399711, 72.836263, 'CSMT Parking', 'open', 'Rs.60 (first hour)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(20, 19.1698034, 72.9364705, 'BMC Multilevel Parking', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(21, 19.19633977, 72.9784266, 'Thane Collectorate Parking', 'open', 'Free or nominal for government visitors (TMC jurisdiction', 'Government office hours: 10:30 AM – 5:30 PM Mon–Sat (Thane…', 'Not specified', 'Institutional parking', 'Unverified · seed data'),
(22, 18.97868452, 72.83451339, 'Byculla Zoo', 'limited', 'Rs.80 (car, first 3 hrs) + Rs.30/hr after', 'Open Tue–Mon 9:00 AM – 6:00 PM (CLOSED Wednesdays)', 'Not specified', 'Surface lot', 'Verified · seed data'),
(23, 19.21057511, 72.97405285, 'Thane municipal parking plaza', 'open', 'TMC municipal rates (not publicly published as of 2026)', 'Open 24h', 'Not specified', 'Multilevel parking', 'Unverified · seed data'),
(24, 19.1033165, 72.8722305, 'Brihanmumbai Municipal Corporation Pay & Park', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Underground / Basement', 'Unverified · seed data'),
(25, 19.03238375, 72.92385411, 'DCSEM Garage', 'open', 'Rs.65/hr (car)', 'Open 24h', 'Not specified', 'Commercial parking', 'Corroborated · seed data'),
(26, 19.17509878, 72.98892852, 'Newa Bhakti Knowledge City Surface Parking', 'open', 'NMMC jurisdiction (Navi Mumbai Municipal Corporation)', 'During business/resident hours (Newa Bhakti Knowledge City,…', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(27, 19.1035529, 72.8273177, 'Juhu Beach Parking', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(28, 19.03711751, 72.8576288, 'LTMG Sion Hospital Parking', 'open', 'Free or nominal (BMC-run government hospital', 'Open 24h', 'Not specified', 'Institutional parking', 'Corroborated · seed data'),
(29, 19.09932327, 72.91656686, 'YouMee R City Mall', 'open', 'Rs 30 per entry (4W)', '11 AM - 9:30 PM Mon-Thu', 'Not specified', 'Multilevel parking', 'Corroborated · seed data'),
(30, 19.04538843, 72.90316924, 'Cubic Mall - Chembur', 'limited', '₹50 (first 3 hrs, 4W)', 'Opens 10:00 AM (mall hours', 'Not specified', 'Commercial parking', 'Corroborated · seed data'),
(31, 19.05237191, 72.90172034, 'Cinepolis', 'limited', 'Rs 60 (cash only per ParkPlus listing', '~10 AM - 11 PM (mall/cinema operating hours', 'Cash', 'Multilevel parking', 'Unverified · seed data'),
(32, 19.04871526, 72.87468158, 'Parking Area', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Weekdays 9 AM - 9 PM', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(33, 19.04888747, 72.87329713, 'KJ Somaiya Campus Parking', 'open', 'Visitors: Rs 20-50/entry (estimated)', 'Campus hours: 7 AM - 10 PM (approx.)', 'Not specified', 'Institutional parking', 'Unverified · seed data'),
(34, 19.21890837, 72.97057846, 'Pay & Park/rutu enterprises', 'open', 'Not published', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(35, 19.21719601, 72.98023984, 'Bike Park (but looks like cars are also there)', 'open', 'Rs 10-20/day (informal two-wheeler parking, Thane rates)', 'Approx. 8 AM - 10 PM (informal two-wheeler lot)', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(36, 19.09941972, 72.86760498, 'Sahar Ayyappa Shiva Parvati Temple Parking Lot and Entrance', 'open', 'Free', 'Park open Tue–Sun 7:30 AM – 6:30 PM', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(37, 19.1797279, 72.94595992, 'BMC public parking in the basement', 'limited', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Underground / Basement', 'Unverified · seed data'),
(38, 19.23199515, 72.86403798, 'SGNP Parking Ground', 'open', 'Rs 242 per car (vehicle entry fee included with park admission)', '7:30 AM - 6:30 PM (Sanjay Gandhi National Park gate hours)', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(39, 19.14743131, 72.85505704, 'NESCO Parking lot', 'open', 'Rates vary by event', 'Event-based (NESCO operates only during exhibitions/events)', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(40, 19.04099131, 72.85335827, 'Asif ola parking', 'open', '4W: ₹25 (≤1hr) / ₹30 (1–3hr) / ₹40 (3–6hr) / ₹70 (6–12hr)', 'Approx. 7 AM - 10 PM (informal operator-run lot)', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(41, 19.2886181, 72.86755298, 'MBMC Parking Lot', 'open', '2W: Rs 20/12hr, Rs 25/24hr (MBMC published rate)', 'Open 24h', 'Not specified', 'Surface lot', 'Corroborated · seed data'),
(42, 19.28823727, 72.87114988, 'Bhagwan Shri Parshuram Vahansthal', 'open', 'Free or nominal donation (religious vahansthal)', 'During temple/religious event hours (approx. 6 AM - 9 PM)', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(43, 19.2396647, 72.8479501, 'BMC PARKING TOWER A', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Multilevel parking', 'Unverified · seed data'),
(44, 19.1596483, 72.944394, 'MCGM', 'open', 'MCGM standard suburban rates', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(45, 19.18132052, 72.94681316, 'BMC PARKING', 'open', '4W: ₹25 (≤1hr) / ₹30 (1–3hr) / ₹40 (3–6hr) / ₹70 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(46, 19.12921789, 72.93074796, 'BMC PARKING', 'open', '4W: ₹25 (≤1hr) / ₹30 (1–3hr) / ₹40 (3–6hr) / ₹70 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(47, 19.11375441, 72.89209014, 'BMC PARKING TOWER A', 'open', '4W: ₹25 (≤1hr) / ₹30 (1–3hr) / ₹40 (3–6hr) / ₹70 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(48, 19.13012717, 72.82300113, 'BMC Parking', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(49, 19.065537, 72.830234, 'MCGM Pay and park on streeets of bandra !!!', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'On-street parking', 'Unverified · seed data'),
(50, 19.22705541, 72.98935303, 'NaMo Grand Central Park Parking', 'open', '₹40 (4-wheeler)', '6 AM - 9 PM daily (NaMo Grand Central Park operating hours)', 'Cash', 'Surface lot', 'Corroborated · seed data'),
(51, 18.92357251, 72.96746453, 'BUS Parking', 'open', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Bus / Truck parking', 'Unverified · seed data'),
(52, 18.92528831, 72.83224509, 'Paid Parking', 'limited', '4W: ₹15 (≤1hr) / ₹15 (1–3hr) / ₹20 (3–6hr) / ₹35 (6–12hr)', 'Open 24h', 'Not specified', 'Commercial parking', 'Unverified · seed data'),
(53, 19.07564851, 72.89976957, 'Somaiya Parking Ground', 'open', 'Visitor parking: approx. Rs 20-50 (estimated)', 'Campus hours: 7 AM - 10 PM (approx.)', 'Not specified', 'Surface lot', 'Unverified · seed data'),
(54, 19.005194, 72.826722, 'Utopia City Pay and Park', 'open', '4W: ₹25 (≤1hr) / ₹30 (1–3hr) / ₹40 (3–6hr) / ₹70 (6–12hr)', 'Open 24h', 'Not specified', 'Commercial parking', 'Unverified · seed data'),
(55, 19.00377979, 72.83017111, 'MCGM Lodha Parking Pay and Park', 'open', '4W: ₹35 (≤1hr) / ₹45 (1–3hr) / ₹60 (3–6hr) / ₹100 (6–12hr)', 'Open 24h', 'Not specified', 'Commercial parking', 'Unverified · seed data'),
(56, 18.990963184887967, 72.81929175, 'Nehru Science Centre Parking', 'open', '₹60 (4-wheeler)', '11:30 AM – 8:00 PM (open all days including weekends and pu…', 'Not specified', 'Institutional parking', 'Verified · seed data');
