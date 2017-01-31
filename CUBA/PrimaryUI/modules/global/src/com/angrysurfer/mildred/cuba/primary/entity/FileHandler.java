package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "file_handler")
@Entity(name = "primary$FileHandler")
public class FileHandler extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -1105649790128252108L;

    @Column(name = "package", length = 128)
    protected String _package;

    @Column(name = "module", nullable = false, length = 128)
    protected String module;

    @Column(name = "class_name", length = 128)
    protected String className;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    public void set_package(String _package) {
        this._package = _package;
    }

    public String get_package() {
        return _package;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getModule() {
        return module;
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