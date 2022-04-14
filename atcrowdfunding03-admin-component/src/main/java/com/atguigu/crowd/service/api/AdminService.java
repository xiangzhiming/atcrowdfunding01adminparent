package com.atguigu.crowd.service.api;

import com.github.pagehelper.PageInfo;

import java.util.List;

public interface AdminService {
    void saveAdmin(Admin admin);

    List<Admin> getAll();

    Admin getAdminByLoginAcct(String loginAcct, String userPswd);

    PageInfo<Admin> getPageInfo(String keyWord,Integer pageNum,Integer pageSize);

    void remove(Integer adminid);

    Admin getadminById(Integer adminID);

    void update(Admin admin);
}
