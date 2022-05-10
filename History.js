import { useEffect, useState } from "react";
import { getTaskToCurrentUser } from "../store/action/index";
//import { CardGroup } from "react-bootstrap"

import ToDo from "./ToDo"
import { useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";

const History = () => {
    let user = useSelector(state => state.currentUser)
    let arrT = useSelector(state => state.taskArr)
    let search = useSelector(state => state.search)
    console.log("search::::::::::",search);

    let navigate = useNavigate()
    useEffect(() => {
        if (!user) {
            navigate('/login')
        }

        // dispatch(getTaskToCurrentUser(user.id)).then((res) => {
        //     console.log("res", res);
        //     let a = res
        //     console.log("a", a);
        //     setArr(a)
        // }, (e) => console.log(e, "שגיאה"))
    }, []);

    return (<>
        <h1>my history:</h1>
        {/* <CardGroup> */}
            {arrT.filter(t => t.completed)
                .filter(t => t.title.includes(search))
                .map(item => <ToDo key={item.id} task={item} disable={true} />)}
        {/* </CardGroup> */}
    </>);
}

export default History;