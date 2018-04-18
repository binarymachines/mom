package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import com.haulmont.chile.core.annotations.NamePattern;

@NamePattern("%s %s|moduleName,className")
@DesignSupport("{'imported':true}")
@Table(name = "file_handler")
@Entity(name = "mildred$FileHandler")
public class FileHandler extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 970068486027491599L;

    @Column(name = "package_name", length = 128)
    protected String packageName;

    @Column(name = "module_name", nullable = false, length = 128)
    protected String moduleName;

    @Column(name = "class_name", length = 128)
    protected String className;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

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

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }


}