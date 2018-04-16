package com.company.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "file_handler_registration")
@Entity(name = "mildred$FileHandlerRegistration")
public class FileHandlerRegistration extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 255605975554223051L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "file_handler_id")
    protected FileHandler fileHandler;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "file_type_id")
    protected FileType fileType;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setFileHandler(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    public FileHandler getFileHandler() {
        return fileHandler;
    }

    public void setFileType(FileType fileType) {
        this.fileType = fileType;
    }

    public FileType getFileType() {
        return fileType;
    }


}