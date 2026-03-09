package com.example.mybatisplusdemo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.mybatisplusdemo.model.domain.Orders;
import com.example.mybatisplusdemo.model.vo.OrdersVO;
import com.example.mybatisplusdemo.model.vo.UserVO;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jkx
 * @since 2025-06-30
 */
public interface OrdersMapper extends BaseMapper<Orders> {

    OrdersVO selectVOById(@Param("id") int i);


}
