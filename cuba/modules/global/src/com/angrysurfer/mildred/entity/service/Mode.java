package com.angrysurfer.mildred.entity.service;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "mode")
@Entity(name = "mildred$Mode")
public class Mode extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 5434325976931927183L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "stateful_flag", nullable = false)
    protected Boolean statefulFlag = false;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setStatefulFlag(Boolean statefulFlag) {
        this.statefulFlag = statefulFlag;
    }

    public Boolean getStatefulFlag() {
        return statefulFlag;
    }


}