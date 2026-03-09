import request from "@/utils/request";

export const pageStudents = (query) => request.get("/api/student/listPage", { params: query });