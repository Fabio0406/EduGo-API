import { Router } from "express"
import {Añadir, IniciarSC, IniciarSP, RegitrarB, RegitrarC, RegitrarP, RegitrarV, estado, refresh, solicitudes } from "../controllers/Usuario.c.js";
import {dirname, join} from 'path';
import {fileURLToPath} from 'url';
import multer from 'multer';

const __dirname = dirname(fileURLToPath(import.meta.url));
export const storage = multer.diskStorage({
    destination: (req,file,cb) => {
        cb(null, join(__dirname,'../public/images'))
    },
    filename: (req,file,cb) =>{
        const ext = file.originalname.split('.').pop()
        cb(null,`${Date.now()}.${ext}`)
    }
})

const usua = Router();
const upload = multer({storage})

usua.post('/IniciarSP',IniciarSP)
usua.post('/IniciarSC',IniciarSC)
usua.post('/RegisP',upload.single("foto"),RegitrarP)
usua.post('/RegisC',upload.single("foto"),RegitrarC)
usua.post('/RegisB',upload.single("foto"),RegitrarB)
usua.post('/RegisV',upload.single("foto"),RegitrarV)
usua.post('/posicion/:usua/:ci',refresh)
// La ruta lleva ñ: se registra también codificada (como la envían navegadores y apps) y sin ñ
usua.post(['/AñadirS', encodeURI('/AñadirS'), '/AnadirS'],Añadir)
usua.get('/solicitudes',solicitudes)

usua.post('/posicion/estado/:usua/:ci',estado)

export default usua