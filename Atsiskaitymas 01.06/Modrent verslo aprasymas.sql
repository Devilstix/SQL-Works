			-- ======================== --
-- ========== UAB MODERENT ========== --
			-- ======================== --


    ## Verslo idėja:

	„UAB Moderent“ – tai automobilių nuomos įmonė, teikianti įvairių tipų automobilių nuomos paslaugas pagrindiniuose Lietuvos miestuose. Įmonė leidžia klientams 
pasirinkti automobilį, nuomotis tam tikram laikotarpiui bei atsiskaityti įvairiais būdais (kortele, grynaisiais, bankiniu pavedimu ar internetu).
 
    ## Verslo tikslas:

$$ Suteikti klientams patogią, greitą ir patikimą automobilio nuomos paslaugą.
$$ Efektyviai valdyti automobilių parką ir stebėti nuomas 
$$ Didinti pajamas per nuomos procesų ir mokėjimų valdymą.

   ## Lentelių paaiškinimas

Lentelė						Verslo atitikmuo / ką atspindi

Vartotojai					Įmonės klientai, kurie nuomoja automobilius. Saugo asmens informaciją (vardas, pavardė, kontaktai).
Darbuotojai				Įmonės darbuotojai, aptarnaujantys klientus. Saugo informaciją apie personalą.
Vietoves						Nuomos punktai / lokacijos (paėmimo ir grąžinimo vietos). Leidžia valdyti automobilių judėjimą skirtinguose centruose.
KebuloTipas				Automobilio kėbulo tipai (sedanas, SUV, hečbekas, kabrioletas, universalas). Padeda analizuoti populiariausius automobilių tipus.
Masinos						Automobiliai, kuriuos galima išsinuomoti. Saugo gamintoją, modelį, kuro tipą, pagaminimo metai, valstybinius numerius ir dienos kainą.
Nuomos						Visos įvykdytos nuomos. Įrašo, kuris klientas, kurioje vietoje, kokį automobilį, kuriam laikui ir per kurį darbuotoją nuomojosi.
Mokejimai					Įvykdyti mokėjimai už nuomas. Įrašo sumą, datą ir mokėjimo būdą. Padeda stebėti pajamas ir finansinę statistiką.

  ## Ryšiai tarp lentelių

Iš lentelės										Į lentelę								Tipas

nuomos.VartotojoID				vartotojai.VartotojoID				N:1
nuomos.MasinosID				masinos.MasinosID					N:1
nuomos.DarbuotojoID			darbuotojai.DarbuotojoID		N:1
nuomos.PaemimoVietaID	vietoves.VietovesID					N:1
nuomos.PalikimoVietaID		vietoves.VietovesID					N:1
nasinos.KebuloTipoID			kebuloTipas.KebuloTipoID		N:1
mokejimai.NuomosID			nuomos.NuomosID					N:1



