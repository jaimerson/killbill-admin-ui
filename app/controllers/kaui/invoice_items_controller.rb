class Kaui::InvoiceItemsController < Kaui::EngineController
  def index
    if params[:invoice_item_id].present? and params[:invoice_id].present?
      redirect_to kaui_engine.invoice_item_path(params[:invoice_item_id], :invoice_id => params[:invoice_id])
    end
  end

  def show
    find_invoice_item
  end

  def edit
    find_invoice_item
  end

  def update
    @invoice_item = Kaui::InvoiceItem.new(params[:invoice_item])
    success = Kaui::KillbillHelper.adjust_invoice(@invoice_item, current_user, params[:reason], params[:comment])
    if success
      flash[:notice] = "Adjustment item created"
      redirect_to kaui_engine.invoice_path(@invoice_item.invoice_id)
    else
      flash[:error] = "Unable to create adjustment item"
      render :action => "edit"
    end
  end

  private

  def find_invoice_item
    invoice_item_id = params[:id]
    invoice_id = params[:invoice_id]
    if invoice_item_id.present? and invoice_id.present?
      @invoice_item = Kaui::KillbillHelper.get_invoice_item(invoice_id, invoice_item_id)
      unless @invoice_item.present?
        flash[:error] = "Invoice for id #{invoice_id} and invoice item id #{invoice_item_id} not found"
        render :action => :index
      end
    else
      flash[:error] = "Both invoice item and invoice ids should be specified"
      render :action => :index
    end
  end
end
