class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-08-17.tar.gz"
  version "2020-08-17"
  sha256 "fd2af7d8709cf761c341ebcc7e738b235762dc887947c8990f39d838ffafa194"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c5bd6e2b36e6e1cdd7dddb724497c63475b996e605b5024e53367c038bb113b" => :catalina
    sha256 "96dcff8635cfc6c083094589f42a6d6773768a1a52791e9b5ab4af0ce2db2373" => :mojave
    sha256 "bba4c860f6cc2c27031873f326b1db9956b837d0ec9e4161ab4856ce57f7254d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
