class HolosTdaCheck < Formula
  desc "Independent checker for proof-carrying holos persistence"
  homepage "https://github.com/t0rsion/holos"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-check-aarch64-apple-darwin.tar.xz"
      sha256 "0017081e6799dfffd82d8a841370e020ecc2a6cff4df5a7d6068630c8e90bcb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-check-x86_64-apple-darwin.tar.xz"
      sha256 "37b8f6492f644329a587202a567c2d69e901b83b2ceb5134bf9036643daca149"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-check-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9fe3cce889b93fa7f90de2f3a423156805b9bf58cf8dd252a7c85440e0a0b665"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-check-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b8d3dbd5553fdb2b59e833a5121a694d7130850e17ce317352217b12267dba17"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos-check"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
