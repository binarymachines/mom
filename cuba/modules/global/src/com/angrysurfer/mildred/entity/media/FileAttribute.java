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
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

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

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open", "clear"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "file_encoding_id")
    protected FileEncoding encoding;

    @Column(name = "file_format", nullable = false, length = 32)
    protected String fileFormat;

    @Column(name = "attribute_name", nullable = false, length = 128)
    protected String attributeName;

    public void setEncoding(FileEncoding encoding) {
        this.encoding = encoding;
    }

    public FileEncoding getEncoding() {
        return encoding;
    }


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


}