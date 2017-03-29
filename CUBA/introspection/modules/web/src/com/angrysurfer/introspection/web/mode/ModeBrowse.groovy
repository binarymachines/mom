package com.angrysurfer.introspection.web.mode

import com.angrysurfer.introspection.entity.Mode
import com.haulmont.cuba.core.entity.Entity
import com.haulmont.cuba.gui.components.*
import com.haulmont.cuba.gui.components.actions.CreateAction;
import com.haulmont.cuba.gui.components.actions.EditAction
import com.haulmont.cuba.gui.components.actions.RemoveAction
import com.haulmont.cuba.gui.data.CollectionDatasource
import com.haulmont.cuba.gui.data.DataSupplier
import com.haulmont.cuba.gui.data.Datasource

import javax.inject.Inject
import javax.inject.Named

class ModeBrowse extends AbstractLookup {

    /**
     * The {@link CollectionDatasource} instance that loads a list of {@link Mode} records
     * to be displayed in {@link ModeBrowse#modesTable} on the left
     */
    @Inject
    private CollectionDatasource<Mode, UUID> modesDs

    /**
     * The {@link Datasource} instance that contains an instance of the selected entity
     * in {@link ModeBrowse#modesDs}
     * <p/> Containing instance is loaded in {@link CollectionDatasource#addItemChangeListener}
     * with the view, specified in the XML screen descriptor.
     * The listener is set in the {@link ModeBrowse#init(Map)} method
     */
    @Inject
    private Datasource<Mode> modeDs

    /**
     * The {@link Table} instance, containing a list of {@link Mode} records,
     * loaded via {@link ModeBrowse#modesDs}
     */
    @Inject
    private Table<Mode> modesTable

    /**
     * The {@link BoxLayout} instance that contains components on the left side
     * of {@link SplitPanel}
     */
    @Inject
    private BoxLayout lookupBox

    /**
     * The {@link BoxLayout} instance that contains buttons to invoke Save or Cancel actions in edit mode
     */
    @Inject
    private BoxLayout actionsPane

    /**
     * The {@link FieldGroup} instance that is linked to {@link ModeBrowse#modeDs}
     * and shows fields of the selected {@link Mode} record
     */
    @Inject
    private FieldGroup fieldGroup
    
    /**
     * The {@link RemoveAction} instance, related to {@link ModeBrowse#modesTable}
     */
    @Named("modesTable.remove")
    private RemoveAction modesTableRemove
    
    @Inject
    private DataSupplier dataSupplier

    /**
     * {@link Boolean} value, indicating if a new instance of {@link Mode} is being created
     */
    private boolean creating;

    @Override
    public void init(Map<String, Object> params) {

        /*
         * Adding {@link com.haulmont.cuba.gui.data.Datasource.ItemChangeListener} to {@link modesDs}
         * The listener reloads the selected record with the specified view and sets it to {@link modeDs}
         */
        modesDs.addItemChangeListener({def e ->
            if (e.getItem() != null) {
                Mode reloadedItem = dataSupplier.reload(e.getDs().getItem(), modeDs.getView())
                modeDs.setItem(reloadedItem)
            }
        })
        
        /*
         * Adding {@link CreateAction} to {@link modesTable}
         * The listener removes selection in {@link modesTable}, sets a newly created item to {@link modeDs}
         * and enables controls for record editing
         */
        modesTable.addAction(new CreateAction(modesTable) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity newItem, Datasource parentDs, Map<String, Object> openParams) {
                modesTable.setSelected(Collections.emptyList())
                modeDs.setItem((Mode) newItem)
                refreshOptionsForLookupFields()
                enableEditControls(true)
            }
        })

        /*
         * Adding {@link EditAction} to {@link modesTable}
         * The listener enables controls for record editing
         */
        modesTable.addAction(new EditAction(modesTable) {
            @Override
            protected void internalOpenEditor(CollectionDatasource datasource, Entity existingItem, Datasource parentDs, Map<String, Object> openParams) {
                if (modesTable.getSelected().size() == 1) {
                    refreshOptionsForLookupFields()
                    enableEditControls(false)
                }
            }
        })
        
        /*
         * Setting {@link RemoveAction#afterRemoveHandler} for {@link modesTableRemove}
         * to reset record, contained in {@link modeDs}
         */
        modesTableRemove.setAfterRemoveHandler({def removedItems -> modeDs.setItem(null)})
        
        disableEditControls()
    }

    private void refreshOptionsForLookupFields() {
        for (Component component : fieldGroup.getOwnComponents()) {
            if (component instanceof LookupField) {
                CollectionDatasource optionsDatasource = ((LookupField) component).getOptionsDatasource()
                if (optionsDatasource != null) {
                    optionsDatasource.refresh()
                }
            }
        }
    }

    /**
     * Method that is invoked by clicking Save button after editing an existing or creating a new record
     */
    public void save() {
        if (!validate(Collections.singletonList(fieldGroup))) {
            return
        }
        getDsContext().commit()

        Mode editedItem = modeDs.getItem()
        if (creating) {
            modesDs.includeItem(editedItem)
        } else {
            modesDs.updateItem(editedItem)
        }
        modesTable.setSelected(editedItem)

        disableEditControls()
    }

    /**
     * Method that is invoked by clicking Save button after editing an existing or creating a new record
     */
    public void cancel() {
        Mode selectedItem = modesDs.getItem()
        if (selectedItem != null) {
            Mode reloadedItem = dataSupplier.reload(selectedItem, modeDs.getView())
            modesDs.setItem(reloadedItem)
        } else {
            modeDs.setItem(null)
        }

        disableEditControls()
    }

    /**
     * Enabling controls for record editing
     * @param creating indicates if a new instance of {@link Mode} is being created
     */
    private void enableEditControls(boolean creating) {
        this.creating = creating
        initEditComponents(true)
        fieldGroup.requestFocus()
    }

    /**
     * Disabling editing controls
     */
    private void disableEditControls() {
        initEditComponents(false)
        modesTable.requestFocus()
    }

    /**
     * Initiating edit controls, depending on if they should be enabled/disabled
     * @param enabled if true - enables editing controls and disables controls on the left side of the splitter
     *                if false - visa versa
     */
    private void initEditComponents(boolean enabled) {
        
            fieldGroup.setEditable(enabled)
        

        actionsPane.setVisible(enabled)
        lookupBox.setEnabled(!enabled)
    }
}