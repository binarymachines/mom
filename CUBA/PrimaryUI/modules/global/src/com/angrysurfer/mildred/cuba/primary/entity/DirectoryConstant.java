package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['effective_dt','expiration_dt']}")
@Table(name = "directory_constant")
@Entity(name = "primary$DirectoryConstant")
public class DirectoryConstant extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -6537673631020349719L;

    @Column(name = "index_name", nullable = false, length = 128)
    protected String indexName;

    @Column(name = "pattern", nullable = false, length = 256)
    protected String pattern;

    @Column(name = "location_type", nullable = false, length = 64)
    protected String locationType;

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public String getPattern() {
        return pattern;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public String getLocationType() {
        return locationType;
    }


}