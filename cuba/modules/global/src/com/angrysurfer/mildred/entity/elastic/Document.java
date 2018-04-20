package com.angrysurfer.mildred.entity.elastic;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import com.haulmont.cuba.core.entity.BaseStringIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "document")
@Entity(name = "mildred$Document")
public class Document extends BaseStringIdEntity {
    private static final long serialVersionUID = 6268974233147975405L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "document_type_id")
    protected DocumentType documentType;

    @Column(name = "document_type", nullable = false, length = 64)
    protected String documentType1;

    @Column(name = "absolute_path", nullable = false, length = 1024)
    protected String absolutePath;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "effective_dt")
    protected Date effectiveDt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "expiration_dt")
    protected Date expirationDt;

    @Id
    @Column(name = "id", nullable = false, length = 128)
    protected String id;

    public void setDocumentType(DocumentType documentType) {
        this.documentType = documentType;
    }

    public DocumentType getDocumentType() {
        return documentType;
    }

    public void setDocumentType1(String documentType1) {
        this.documentType1 = documentType1;
    }

    public String getDocumentType1() {
        return documentType1;
    }

    public void setAbsolutePath(String absolutePath) {
        this.absolutePath = absolutePath;
    }

    public String getAbsolutePath() {
        return absolutePath;
    }

    public void setEffectiveDt(Date effectiveDt) {
        this.effectiveDt = effectiveDt;
    }

    public Date getEffectiveDt() {
        return effectiveDt;
    }

    public void setExpirationDt(Date expirationDt) {
        this.expirationDt = expirationDt;
    }

    public Date getExpirationDt() {
        return expirationDt;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }


}