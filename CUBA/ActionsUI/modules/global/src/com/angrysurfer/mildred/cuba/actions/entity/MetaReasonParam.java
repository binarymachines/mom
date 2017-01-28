package com.angrysurfer.mildred.cuba.actions.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@DesignSupport("{'imported':true,'unmappedColumns':['meta_reason_id']}")
@Table(name = "meta_reason_param")
@Entity(name = "actionsui$MetaReasonParam")
public class MetaReasonParam extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -2130734615417901722L;

    @Column(name = "vector_param_name", nullable = false, length = 128)
    protected String vectorParamName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meta_reason_id")
    protected MetaReason metaReason;

    public void setMetaReason(MetaReason metaReason) {
        this.metaReason = metaReason;
    }

    public MetaReason getMetaReason() {
        return metaReason;
    }


    public void setVectorParamName(String vectorParamName) {
        this.vectorParamName = vectorParamName;
    }

    public String getVectorParamName() {
        return vectorParamName;
    }


}