import axios from "axios"
export const addUser = (user, navigate) => {
    return (
        (dispatch) => {
            axios.post("https://jsonplaceholder.typicode.com/users", user).then(
                res => {
                    dispatch(saveUser(res.data))
                    navigate('/dialoge')
                }, err => {
                    console.log(err);
                    console.log("occur err");

                })

        })
}
const saveUser = (user) => {
    return {
        type: "USER_ADDED",
        payload: user
    }
}
export const logout = () => {
    return {
        type: "USER_LOGOUT"
    }
}
export const authenticationUser = (user, navigate) => {
    return (
        (dispatch) => {
            axios.get("https://jsonplaceholder.typicode.com/users").then(
                res => {
                    let cu = res.data.find(_ => _.username === user.username && _.email === user.email)
                    console.log(cu, res.data);
                    if (cu)
                        axios.get(`https://jsonplaceholder.typicode.com/todos?userId=${cu.id}`).then(
                            res => {
                                console.log(res.data);
                                let tasks = [...res.data]
                                dispatch(currentUser(cu, tasks))
                                navigate('/todo')
                            }, err => {
                                console.log(err);
                                console.log("occur err");
                            })
                }, err => {
                    console.log(err);
                    console.log("occur err");
                })
        })
}
const currentUser = (user, task) => {
    return {
        type: "CURRENT_USER",
        payload: { user, task }
    }
}

