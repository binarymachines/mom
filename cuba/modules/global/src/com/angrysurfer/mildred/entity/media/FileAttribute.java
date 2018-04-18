package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "file_attribute")
@Entity(name = "mildred$FileAttribute")
public class FileAttribute extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 8415889238669739474L;

    @JoinTable(name = "alias_file_attribute",
        joinColumns = @JoinColumn(name = "file_attribute_id"),
        inverseJoinColumns = @JoinColumn(name = "alias_id"))
    @ManyToMany
    protected List<Alias> alias;

    @Column(name = "file_format", nullable = false, length = 32)
    protected String fileFormat;

    @Column(name = "attribute_name", nullable = false, length = 128)
    protected String attributeName;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    public void setAlias(List<Alias> alias) {
        this.alias = alias;
    }

    public List<Alias> getAlias() {
        return alias;
    }

    public void setFileFormat(String fileFormat) {
        this.fileFormat = fileFormat;
    }

    public String getFileFormat() {
        return fileFormat;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }


}