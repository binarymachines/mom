package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "directory_attribute")
@Entity(name = "mildred$DirectoryAttribute")
public class DirectoryAttribute extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 500655340368528018L;

    @Column(name = "directory_id", nullable = false)
    protected Integer directory;

    @Column(name = "attribute_name", nullable = false, length = 256)
    protected String attributeName;

    @Column(name = "attribute_value", length = 512)
    protected String attributeValue;

    public void setDirectory(Integer directory) {
        this.directory = directory;
    }

    public Integer getDirectory() {
        return directory;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeValue(String attributeValue) {
        this.attributeValue = attributeValue;
    }

    public String getAttributeValue() {
        return attributeValue;
    }


}