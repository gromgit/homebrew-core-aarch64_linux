class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/c9/4d/dd06d8787f8faa8c50a422abd9ba14be15ee0b5830e745033815c49d5313/borgbackup-1.1.15.tar.gz"
  sha256 "49cb9eed98b8e32ae3b97beaedf94cdff46f796445043f1923fd0fce7ed3c2bc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "f947520a2800099bca60f8123095921405435a7424b85cbf0e9b071e4f751015" => :big_sur
    sha256 "7ed4740d804cc059161fc72699ca6414f83bf9d656677bc3f9743e743c050768" => :catalina
    sha256 "f7eecc8b325130bf49bd86cb608b3ef124f04eaf0d3c7e8131baa8f0ee0659df" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "xxhash"
  depends_on "zstd"

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@1.1"].prefix
    virtualenv_install_with_resources
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
