class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.2.0.tar.gz"
  sha256 "cafc57b2f2e29f204c00842541691038abcc4e639dd78485f9c042c93335f286"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wsk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b689b59b4f1577af8ea4a96cb3a2c483db5440d5555c9ab673ae8fb79977abad"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
