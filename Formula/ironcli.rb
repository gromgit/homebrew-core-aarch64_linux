class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.6.tar.gz"
  sha256 "2b9e65c36e4f57ccb47449d55adc220d1c8d1c0ad7316b6afaf87c8d393caae6"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ironcli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ae51ad5993f2888c9352bb0515cb21e5879ab818b9aee9c94dfef5c05c54209b"
  end

  deprecate! date: "2021-07-29", because: :unmaintained

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/iron-io/ironcli").install buildpath.children
    cd "src/github.com/iron-io/ironcli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"iron"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
