class AddGithubPrAuthorVerifiedToInvoiceLineItems < ActiveRecord::Migration[8.0]
  def change
    add_column :invoice_line_items, :github_pr_author_verified, :boolean
  end
end
