package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['effective_dt','expiration_dt']}")
@NamePattern("%s|name")
@Table(name = "directory")
@Entity(name = "primary$Directory")
public class Directory extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -6619048595786490815L;

    @Column(name = "index_name", nullable = false, length = 128)
    protected String indexName;

    @Column(name = "name", nullable = false, length = 767)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "file_type_id")
    protected FileType fileType;

    @Column(name = "CATEGORY_PROTOTYPE_FLAG", nullable = false)
    protected Boolean categoryPrototypeFlag = false;

    @Column(name = "ACTIVE_FLAG", nullable = false)
    protected Boolean activeFlag = false;

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setFileType(FileType fileType) {
        this.fileType = fileType;
    }

    public FileType getFileType() {
        return fileType;
    }

    public void setCategoryPrototypeFlag(Boolean categoryPrototypeFlag) {
        this.categoryPrototypeFlag = categoryPrototypeFlag;
    }

    public Boolean getCategoryPrototypeFlag() {
        return categoryPrototypeFlag;
    }

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }


}