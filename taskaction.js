import axios from "axios"

export const addTask = (task,navigate) => {
    return (
        (dispatch) => {
            axios.post("https://jsonplaceholder.typicode.com/todos", task).then(
                res => {
                    dispatch(saveTask(res.data))
                    navigate('/todo')
                }, err => {
                    console.log(err);
                    console.log("occur err");

                })

        })
}
const saveTask = (task) => {
    return {
        type: "SAVE_TASK",
        payload: task
    }
}
// ---------------------------------סימון v/x
export const taskCompleted = (task) => {
    return (
        (dispatch) => {
            axios.patch(`https://jsonplaceholder.typicode.com/todos/${task.id}`, {completed:true}).then(
                res => {
                    console.log("res",res);
                    dispatch(completeTask(task));
                }, err => {
                    console.log(err);
                    console.log("occur err");

                })

        })
}
const completeTask = (task) => {
    return {
        type: "TASK_COMPLATED",
        payload: task
    }
}
export const taskDeleted = (task) => {
    return (
        (dispatch) => {
            axios.delete(`https://jsonplaceholder.typicode.com/todos/${task.id}`).then(
                res => {
                    console.log("res--deleted",task);
                    dispatch(deleteTask(task))
                   
                }, err => {
                    console.log(err);
                    console.log("occur err");

                })

        })
}
const deleteTask = (task) => {
    return {
        type: "TASK_DELETED",
        payload: task
    }
}
export const search_add = (word) => {
    return {
        type: "SEARCH_ADDED",
        payload: word
    }
}