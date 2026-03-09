package com.example.mybatisplusdemo.model.vo;

import com.example.mybatisplusdemo.model.domain.Orders;
import com.example.mybatisplusdemo.model.domain.User;
import lombok.Data;

@Data
public class OrdersVO extends Orders {
    private User user;
}
