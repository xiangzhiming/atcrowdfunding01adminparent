package com.atguigu.crowd.test;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.mapper.AdminMapper;

import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class CrowdTest {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private AdminService adminService;

    @Autowired
    private RoleMapper roleMapper;


    @Test
    public void testRoleSave() {
        for (int i = 0; i < 235; i++) {
            roleMapper.insert(new Role(null, "role" + i));
        }
    }

    @Test
    public void test() {
        for (int i = 0; i < 238; i++) {
            adminMapper.insert(new Admin(null,"loginAcct" + i,"userPswd"+i,"userName"+i,"email"+i,null));
        }
    }

    @Test
    public void testTX() {
        Admin admin = new Admin(null, "jerry", "123123", "杰瑞", "tom@qq.com", null);
        if (adminService != null) {
            adminService.saveAdmin(admin);
        }
        System.out.println("空的");

    }


    @Test
    public void logTest() {
        //1.获取Logger对象
        Logger logger = LoggerFactory.getLogger(CrowdTest.class);

        //2.根据不同日志级别打印日志
        logger.debug("Hello I am Debug level!!!!!");
        logger.debug("Hello I am Debug level!!!!!");
        logger.debug("Hello I am Debug level!!!!!");

        logger.warn("Hello I am Warn level!!!!!");
        logger.warn("Hello I am Warn level!!!!!");
        logger.warn("Hello I am Warn level!!!!!");

        logger.error("Hello I am Error level!!!!!");
        logger.error("Hello I am Error level!!!!!");
        logger.error("Hello I am Error level!!!!!");

    }

    @Test
    public void testAdminMapper() {
        Admin admin = new Admin(null, "tom", "123123", "汤姆", "tom@qq.com", null);
        int insert = adminMapper.insert(admin);
        System.out.println("受影响的行数"+insert);
    }

    @Test
    public void testConnection() throws SQLException {
        Connection connection = dataSource.getConnection();
        System.out.println(connection);

    }
}
