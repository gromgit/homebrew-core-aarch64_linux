class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.1.2.tar.gz"
  sha256 "4dc0017e36d15e81dc85953afb2a643ba2571574748db0d8ede002cefbba053b"
  license "MIT"
  revision 1
  head "https://github.com/mruby/mruby.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b4efffa2417122f3afbe67c4159d2e0938161d63a1caddbb7886bc8140eea8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a37241df0d1f4a5a6b2d7a52c1bdf3b9487484b3fce1f90ff49994f6e7095c89"
    sha256 cellar: :any_skip_relocation, catalina:      "13b1277f194b5b75b49d14b8ad814dc3ca0b261edf5d3c741bd99236348b47d3"
    sha256 cellar: :any_skip_relocation, mojave:        "f6bee79071bec85f97704d8b3b7f535a8003d07bf8bb0e0ef556f82fdcb3cb81"
  end

  depends_on "bison" => :build

  uses_from_macos "ruby"

  def install
    inreplace "build_config.rb", /default/, "full-core"
    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system "#{bin}/mruby", "-e", "true"
  end
end
