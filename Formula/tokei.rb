class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v11.1.0.tar.gz"
  sha256 "e74f0c74e80d02ad28da84916871747654c2796e590908412c494a94f8349e3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c736c9456c9e9f6370dbaf35043c1aec6115887ef6005a353ac062fa18a8f000" => :catalina
    sha256 "f197df210e4f15e75491b7a9d0ee837dcbc3f3e3a00d6261961652a624978346" => :mojave
    sha256 "96cbf8d02ee668f98abb6fafa73d74b228b8bab6fdb39b5f3072bceeefff66b2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
