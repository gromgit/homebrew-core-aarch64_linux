class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.10.tar.gz"
  sha256 "8bd8956da925d4f24c45874bc7b9012eb6d8b4aa11cfc9b6b1b7b7c9321365ac"
  license "MIT"
  head "https://github.com/adammck/terraform-inventory.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/terraform-inventory"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6491e03329300c623e55176b4fbccae9b8d167f97b1ca2c59f1d9fff057ccbae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.build_version=#{version}")
  end

  test do
    example = <<~EOS
      {
          "version": 1,
          "serial": 1,
          "modules": [
              {
                  "path": [
                      "root"
                  ],
                  "outputs": {},
                  "resources": {
                      "aws_instance.example_instance": {
                          "type": "aws_instance",
                          "primary": {
                              "id": "i-12345678",
                              "attributes": {
                                  "public_ip": "1.2.3.4"
                              },
                              "meta": {
                                  "schema_version": "1"
                              }
                          }
                      }
                  }
              }
          ]
      }
    EOS
    (testpath/"example.tfstate").write(example)
    assert_match(/example_instance/, shell_output("#{bin}/terraform-inventory --list example.tfstate"))
  end
end
