package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "state")
@Entity(name = "mildred$State")
public class State extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 5534425504314442444L;

    @Column(name = "name", nullable = false, length = 128)
    protected String name;

    @Column(name = "is_terminal_state", nullable = false)
    protected Boolean isTerminalState = false;

    @Column(name = "is_initial_state", nullable = false)
    protected Boolean isInitialState = false;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setIsTerminalState(Boolean isTerminalState) {
        this.isTerminalState = isTerminalState;
    }

    public Boolean getIsTerminalState() {
        return isTerminalState;
    }

    public void setIsInitialState(Boolean isInitialState) {
        this.isInitialState = isInitialState;
    }

    public Boolean getIsInitialState() {
        return isInitialState;
    }


}