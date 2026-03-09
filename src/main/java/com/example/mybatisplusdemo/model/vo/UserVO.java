package com.example.mybatisplusdemo.model.vo;

import com.example.mybatisplusdemo.model.domain.Orders;
import com.example.mybatisplusdemo.model.domain.User;
import lombok.Data;

import java.util.List;

@Data
public class UserVO extends User {
    private List<Orders> orders;
}
