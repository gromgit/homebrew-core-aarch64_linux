class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.4.tar.gz"
  sha256 "8cd1a95827dfd8270927894eb77f62b4087735cbede953884647f16c521c7e58"
  license "BSD-3-Clause"
  head "https://github.com/sparsehash/sparsehash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "baf009352f7372901cb23c3e0db607313809d038d5975fd43195515c448f544c" => :catalina
    sha256 "7042ae9f9b7df36cf6ebfe76704997aa21892c5119adb32c56874954953e9a84" => :mojave
    sha256 "89dbaeb37bfaa056e8c1fd822e585f9ff04001778f646b1ec3f13c85a2ccaedc" => :high_sierra
    sha256 "a0bedeb9128c863130ee3330f65a6c4fe2fb8ca8aeb0aca7abd0ffc2c76691a1" => :sierra
    sha256 "8655e0c3b4f4c69e46d8823eef0d8ae2b1397cd2aa01bda3340eb3a84d647b89" => :el_capitan
    sha256 "b8e55b96aa3016ed2ab5a8d53a4bb39b44773885355ec75e80c9d9ef57c3e8b1" => :yosemite
    sha256 "570c4d250a4fe18d99f11167653a501a1d8a82ff74d2413336a85bc7fa8cbb81" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
