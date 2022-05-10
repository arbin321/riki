// import axios from "axios"
// export const getTaskToCurrentUser = (userId) => {
//     return ((dispatch)=>{axios.get(`https://jsonplaceholder.typicode.com/todos?userId=${userId}`).then(
//         res => {
//             console.log(res.data);
//             return [...res.data]
//             dispatch(saveTask(res.data))
//             // navigate('/dialoge')
//         }, err => {
//             console.log(err);
//             console.log("occur err");
//             return []
//         })})
// }
// const saveTask = (arr) => {
//     return {
//         type: "SAVE_TASKS",
//         payload: arr
//     }
// }

