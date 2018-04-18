package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "alias")
@Entity(name = "mildred$Alias")
public class Alias extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -1989429853331260958L;

    @Column(name = "name", nullable = false, length = 25)
    protected String name;

    @JoinTable(name = "alias_file_attribute",
        joinColumns = @JoinColumn(name = "alias_id"),
        inverseJoinColumns = @JoinColumn(name = "file_attribute_id"))
    @ManyToMany
    protected List<FileAttribute> FileAttribute;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setFileAttribute(List<FileAttribute> FileAttribute) {
        this.FileAttribute = FileAttribute;
    }

    public List<FileAttribute> getFileAttribute() {
        return FileAttribute;
    }


}