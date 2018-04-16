package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "action_dispatch")
@Entity(name = "mildred$ActionDispatch")
public class ActionDispatch extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -7257523008212594383L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "category", length = 128)
    protected String category;

    @Column(name = "package_name", length = 128)
    protected String packageName;

    @Column(name = "module_name", nullable = false, length = 128)
    protected String moduleName;

    @Column(name = "class_name", length = 128)
    protected String className;

    @Column(name = "func_name", nullable = false, length = 128)
    protected String funcName;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getCategory() {
        return category;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getClassName() {
        return className;
    }

    public void setFuncName(String funcName) {
        this.funcName = funcName;
    }

    public String getFuncName() {
        return funcName;
    }


}