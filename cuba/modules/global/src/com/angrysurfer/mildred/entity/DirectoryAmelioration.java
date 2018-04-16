package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "directory_amelioration")
@Entity(name = "mildred$DirectoryAmelioration")
public class DirectoryAmelioration extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -6013248685319027315L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "use_tag")
    protected Boolean useTag;

    @Column(name = "replacement_tag", length = 32)
    protected String replacementTag;

    @Column(name = "use_parent_folder_flag")
    protected Boolean useParentFolderFlag;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setUseTag(Boolean useTag) {
        this.useTag = useTag;
    }

    public Boolean getUseTag() {
        return useTag;
    }

    public void setReplacementTag(String replacementTag) {
        this.replacementTag = replacementTag;
    }

    public String getReplacementTag() {
        return replacementTag;
    }

    public void setUseParentFolderFlag(Boolean useParentFolderFlag) {
        this.useParentFolderFlag = useParentFolderFlag;
    }

    public Boolean getUseParentFolderFlag() {
        return useParentFolderFlag;
    }


}