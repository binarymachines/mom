package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "meta_reason_param")
@Entity(name = "mildred$MetaReasonParam")
public class MetaReasonParam extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -8322288830336184680L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meta_reason_id")
    protected MetaReason metaReason;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_param_id")
    protected VectorParam vectorParam;

    public void setMetaReason(MetaReason metaReason) {
        this.metaReason = metaReason;
    }

    public MetaReason getMetaReason() {
        return metaReason;
    }

    public void setVectorParam(VectorParam vectorParam) {
        this.vectorParam = vectorParam;
    }

    public VectorParam getVectorParam() {
        return vectorParam;
    }


}