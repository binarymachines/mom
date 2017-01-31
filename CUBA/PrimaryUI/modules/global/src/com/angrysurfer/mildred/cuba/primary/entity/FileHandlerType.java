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

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "file_handler_type")
@Entity(name = "primary$FileHandlerType")
public class FileHandlerType extends BaseIdentityIdEntity {
    private static final long serialVersionUID = 760959072995186725L;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "file_handler_id")
    protected FileHandler fileHandler;

    @Column(name = "ext", length = 128)
    protected String ext;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    public void setFileHandler(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    public FileHandler getFileHandler() {
        return fileHandler;
    }

    public void setExt(String ext) {
        this.ext = ext;
    }

    public String getExt() {
        return ext;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}