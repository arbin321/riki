import { useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";

const Dialoge = () => {
    const navigate = useNavigate()
    let user = useSelector(state => state.currentUser)
    if(!user){
        navigate('/login')
    }
    return (<> <p>The registration was successful</p> 
    <button onClick={()=>{
        
        console.log(user);
        navigate('/todo')}
    }>ok</button>
    </>);
}
 
export default Dialoge;