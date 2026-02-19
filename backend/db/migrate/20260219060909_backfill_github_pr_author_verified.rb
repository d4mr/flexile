# frozen_string_literal: true

class BackfillGithubPrAuthorVerified < ActiveRecord::Migration[8.0]
  def up
    # For line items where the contractor still has a GitHub account connected,
    # compute whether the PR author matches their GitHub username.
    execute <<~SQL
      UPDATE invoice_line_items
      SET github_pr_author_verified = (
        LOWER(invoice_line_items.github_pr_author) = LOWER(users.github_username)
      )
      FROM invoices
      JOIN company_contractors ON company_contractors.id = invoices.company_contractor_id
      JOIN users ON users.id = company_contractors.user_id
      WHERE invoice_line_items.invoice_id = invoices.id
        AND invoice_line_items.github_pr_author IS NOT NULL
        AND invoice_line_items.github_pr_author_verified IS NULL
        AND users.github_username IS NOT NULL
    SQL
  end

  def down
    # no-op: we can't distinguish backfilled rows from newly created ones
  end
end
